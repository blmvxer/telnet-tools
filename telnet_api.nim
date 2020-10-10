import tools/fingerprint, tools/bruteforce

#
# telnetFingerprint allows hostFile which is a file with IP Addr's
# seperated line by line. or a hostFile and dictionary
# check services.dict for reference on creating custom dict
#

proc telnetFingerprint*(hostFile: string ) =
  var
    host:string
    hosts = open(hostFile, fmRead)

  let dict = grabServiceAndDict()
  while hosts.readLine(host):
    echo(fingerPrint(host, dict))

proc telnetFingerprint*(hostFile: string, dictionary: string) =
  var
    host: string
    hosts = open(hostFile, fmRead)
    
  let  dict = grabServiceAndDict(dictionary)
  while hosts.readLine(host):
    echo(fingerPrint(host, dict))
