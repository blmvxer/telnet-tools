import net, nativesockets, fab, strutils, os, netTest

var
  services = open("dict/services.dict", fmRead)
  debug: bool
  hostMsgs: seq[string]

debug = false

proc checkOutbound(): bool =
  if testConn("cloudflare", 2000) == @[true, true]:
    return true
  else:
    return false

proc dPrint(dStr: string) =
  if debug == false:
    discard
  else:
    let output = "Debug: " & dStr
    yellow(output)

proc grabServiceAndDict*(): seq[string] =
  var 
    line: string
    list: seq[string]
  while true:
    try:
      line = readLine(services)
      if line.contains("#"):
        discard
      else:
        list.add(line)
    except EOFError:
      return list

proc grabServiceAndDict*(dictionary: string): seq[string] =
  var
    line: string
    list: seq[string]
    dict = open(dictionary, fmRead)
  while true:
    try:
      line = readLine(dict)
      if line.contains("#"):
        discard
      else:
        list.add(line)
    except EOFError:
      return list

proc fingerPrint*(host: string, dictionary: seq[string]): string =
  var
    sock = newSocket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
    line: string
  if checkOutbound() != true:
    sleep(2500)
  else:
    try:
      sock.connect(host, Port(23), 2000)
      echo("Connected: " & host)
      while true:
        line = recvLine(sock, 5000)
        hostMsgs.add(line)
    except:
      let errMsg = ("[!] " & getCurrentExceptionMsg() & "\n")
      dPrint(errMsg)
    finally:
      sock.close()

  for msg in hostMsgs:
    for dict in dictionary:
      let OEM = (dict.split(":")[0])
      let servType = (dict.split(":")[1].split("=")[0])
      let fPrint = (dict.split("=")[1])
      if msg.contains(OEM):
        dPrint(OEM)
        dPrint($msg.contains(OEM))
        if msg.contains(servType):
          dPrint(servType)
          dPrint($msg.contains(servType))
          hostMsgs = @[]
          return ("Found fingerprint: " & fPrint & "\n")


