# !/bin/bash
echo "Dose 2 arithmous:"
read x
read y
echo "Epelekse praksi:"
echo "+"
echo "-"
echo "/"
echo "*"
read ch

case $ch in
+)
apotel=`echo $a + $b | bc`
;;
-)
apotel=`echo $a - $b | bc`
;;
\*)
apotel=`echo $a \* $b | bc`
;;
4)
apotel=`echo "scale=2; $a / $b" | bc`
;;
esac
echo "Apotelesma : $apotel"
