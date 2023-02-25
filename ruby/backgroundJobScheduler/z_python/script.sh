# bash script to randomly add two numbers

# generate two random numbers
a=$RANDOM
b=$RANDOM

# add the two numbers
c=$((a+b))

# sleep for random seconds between 5 and 10

sleep $((RANDOM%6+5))

# print the result
echo "The sum of $a and $b is $c"
