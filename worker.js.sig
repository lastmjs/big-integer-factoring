-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

importScripts('../../node_modules/big-integer/BigInteger.min.js');
var m = bigInt(5);
var i = bigInt(3);
var start = bigInt(3);
var stop = bigInt(5);
var running = false;

function success(p, q, m){
  postMessage({
    type: "SOLUTION_FOUND",
    p: p.toString(),
    q: q.toString(),
    n: m.toString()
  });
}

function requestWork(){
  postMessage(JSON.stringify({
    type: "REQUEST_FOR_WORK"
  }));
}

function setSearchParameters(start, finish, product){
  start = bigInt(start);
  i = bigInt(start);
  stop = bigInt(finish);
  m = bigInt(product);
}

function search(){
  if(i.lesser(stop)){
    if(m.isDivisibleBy(i)){
      console.log(i.toString() + " is a factor of m");
      success(i, m.divide(i), m);
      return;
    }else{
      i = i.plus(2)
      setTimeout(search);
    }
  }
  else{
    requestWork();
  }
}

onmessage = function(e) {
  if(e.data.type === 'WORK_INFO'){
    setSearchParameters(e.data.startIndex, e.data.stopIndex, e.data.product);
    if(running === false){
      search();
      running = true;
    }
  } else if(e.data.type === 'WORK_REQUEST'){
    var p1_startIndex = start;
    var p1_stopIndex =  start.add((stop.subtract(start)).divide(2));
    var p2_startIndex = p1_stopIndex;
    var p2_stopIndex = stop;

    start = p1_startIndex;
    stop = p1_stopIndex;

    postMessage({
      type: 'WORK_INFO',
      peerID: e.data.peerID,
      connectionType: e.data.connectionType,
      thisCurrent: i.toString(),
      thisStart: start.toString(),
      thisStop: stop.toString(),
      startIndex: p2_startIndex.toString(),
      stopIndex: p2_stopIndex.toString(),
      product: m.toString()
    });
  } else{
    console.error("Invalid message type received. Type = " + e.data.type);
  }
}
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJY6RW0AAoJEBxJAvnlJW5iPXIIAKWytxIbTu95YJffYuZqGchx
QemqrH/IXtmNgdSr8VTpmBK9yqPGvGwsHflCPXi3C6OXoDr1nflqqoH/fWZ3ytpe
v2r68dojkEZrDaQLcjsguP4/o3iC72Mpiq0XYowX39kTVZm46L6972jJAFEULHQc
GtqwiZp15/thjx1H+L1Cox1usj8xsCkO86sQ3PiqfjyBGFnyTyNyY84gGkLXzDG3
F9gt8eUu/f+vpewgt3sZ3qRkKoRS9GsjdoWrC8MAGeJZvwLxo/lsp0COOqfedotR
47sgpDCMzKZPI5gmxx5tOUzzl0lvukLq+V+yPm0dbG04Ww9Y+VCFB1JP5XoRSKE=
=kVUy
-----END PGP SIGNATURE-----
