while true; do
        clear
        tail -n 59 extension_*/logs/*.log
        tail -n 59 logs-*/*.log
        sleep 1
done
