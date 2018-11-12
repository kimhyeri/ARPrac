# Creating a Multiuser AR Experience
> Transmit ARKit world-mapping data between nearby devices with the MultipeerConnectivity framework to create a shared basis for AR experiecnces.

## Run the AR Session and Place AR Content

ARWolrTrackingConfiguration with plane detection enable  
run configuration in ARSession  
ARSCNView display AR experience  
UITapGestureRecognizer detects a tap on the screen view

## Connect to peer Devices

- MultipeerConnectivity

- create multipeersession instance  
(MCNearbyService Advertiser to broadcast the devices's ability to join multipeer sessions and an MCNearbyServiceBrowser to find other devices)
  
- when the MCNearbyServiceBrowser finds another device  
it calls browser(_: foundPeer: withDiscoveryInfo: ) delegate method

- when the other device receives invitation  
MCNearbyServiceAdvertiser call advertiser(_: didReceiveInvitaionFrom Peer:withContext:invitaionHandler: ) delegate method
(to accept invitaion)
