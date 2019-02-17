#!/bin/bash
day="$(date +%d -d tomorrow)"

echo "$day"

#if [$day -eq "24"]
if test $day -eq 01
then
curl -k https://url/payment_report/cron_order_payment
curl -k https://url/payment_report/cron_subscription_payment
else

echo "Tomorrow is not firstday of month"

fi
