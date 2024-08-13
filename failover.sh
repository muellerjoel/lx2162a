#!/bin/bash

# Set defaults if not provided by environment
CHECK_DELAY=${CHECK_DELAY:-5}
CHECK_IP=${CHECK_IP:-8.8.8.8}
PRIMARY_IF=${PRIMARY_IF:-eth0}
PRIMARY_GW=${PRIMARY_GW:-1.2.3.4}
BACKUP_IF=${BACKUP_IF:-eth1}
BACKUP_GW=${BACKUP_GW:-2.3.4.5}

# Function to compare argument with the current default gateway interface for the route to the health check IP
gateway_if() {
    [[ "$1" == "$(ip route get "$CHECK_IP" | awk '/dev/ {print $5}')" ]]
}

# Cycle health check continuously with the specified delay
while sleep "$CHECK_DELAY"; do
    if gateway_if "$BACKUP_IF"; then
        # Temporarily add a route to check the primary interface
        ip route add "$CHECK_IP" via "$PRIMARY_GW" dev "$PRIMARY_IF"
        PING_PRIMARY_IF=$(ping -I "$PRIMARY_IF" -c1 "$CHECK_IP" | grep -oP '\d+(?=% packet loss)')
        ip route del "$CHECK_IP" via "$PRIMARY_GW" dev "$PRIMARY_IF"
        sleep 1
    else
        PING_PRIMARY_IF=$(ping -I "$PRIMARY_IF" -c1 "$CHECK_IP" | grep -oP '\d+(?=% packet loss)')
    fi

    # If health check succeeds (i.e., 0% packet loss) from the primary interface
    if [ "$PING_PRIMARY_IF" -eq 0 ]; then
        # Are we currently using the backup interface?
        if gateway_if "$BACKUP_IF"; then
            # Switch to the primary interface
            ip route del default via "$BACKUP_GW" dev "$BACKUP_IF"
            ip route add default via "$PRIMARY_GW" dev "$PRIMARY_IF"
        fi
    else
        # If health check fails (i.e., packet loss > 0%)
        # Are we currently using the primary interface?
        if gateway_if "$PRIMARY_IF"; then
            # Switch to the backup interface
            ip route del default via "$PRIMARY_GW" dev "$PRIMARY_IF"
            ip route add default via "$BACKUP_GW" dev "$BACKUP_IF"
        fi
    fi
done
