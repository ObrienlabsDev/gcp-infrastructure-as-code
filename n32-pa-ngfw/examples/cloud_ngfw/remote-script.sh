ns1=$(curl -s -o /dev/null -w "%{http_code}
" http://www.eicar.org/cgi-bin/.%2e/.%2e/.%2e/.%2e/bin/sh --data "echo Content-Type: text/plain; echo; uname -a" --max-time 2)
ns2=$(curl -s -o /dev/null -w "%{http_code}
" http://www.eicar.org/cgi-bin/user.sh -H "FakeHeader:() { :; }; echo Content-Type: text/html; echo ; /bin/uname -a" --max-time 2)
ns3=$(curl -s -o /dev/null -w "%{http_code}
" http://www.eicar.org/cgi-bin/.%2e/.%2e/.%2e/.%2e/etc/passwd --max-time 2)
ew1=$(curl -w "%{http_code}\n" -s -o /dev/null http://10.0.0.20/cgi-bin/.%2e/.%2e/.%2e/.%2e/bin/sh --data "echo Content-Type: text/plain; echo; uname -a" --max-time 2)
ew2=$(curl -w "%{http_code}\n" -s -o /dev/null http://10.0.0.20/cgi-bin/user.sh -H "FakeHeader:() { :; }; echo Content-Type: text/html; echo ; /bin/uname -a" --max-time 2)
ew3=$(curl -w "%{http_code}\n" -s -o /dev/null http://10.0.0.20/cgi-bin/.%2e/.%2e/.%2e/.%2e/etc/passwd --max-time 2)
echo ""
echo "Response Codes (north/south) :  $ns1 $ns2 $ns3"
echo "Response Codes (east/west)   :  $ew1 $ew2 $ew3"
echo ""

