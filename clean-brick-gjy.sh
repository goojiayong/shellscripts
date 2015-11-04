#!/bin/bash

rm -rf /brick/gjy/*
sleep 3
mkdir -p /brick/gjy/dht-brick/{0..9}
mkdir -p /brick/gjy/ec-brick/{0..9}
mkdir -p /brick/gjy/stripe-brick/{0..9}
mkdir -p /brick/gjy/afr-brick/{0..9}
mkdir -p /brick/gjy/fast-brick/dht/{0..9}
mkdir -p /brick/gjy/fast-brick/ec/{0..9}
mkdir -p /brick/gjy/fast-brick/stripe/{0..9}
mkdir -p /brick/gjy/fast-brick/afr/{0..9}
