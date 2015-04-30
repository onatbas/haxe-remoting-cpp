# HaxeRemotingCpp
Haxe remoting example with neko/cpp server and cpp/flash client

neko.net.ThreadRemotingServer is a very useful class in haxe, I found out that it has 
no particular feature specific to neko so I wanted use it in a c++ server. This repository 
contains source code for a neko/c++ server and c++/flash client. 

This repository is based on haxeChat which can be found [here][haxeChat], to implement c++
client and simplify, I removed chat and added just a value incementation as proof of concept.
I also wrote some comments in classes, for people (like me) who gets a hard time understanding
what the code actually does.


***
[haxeChat]:http://old.haxe.org/doc/flash/chat
