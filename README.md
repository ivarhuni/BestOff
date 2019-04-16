# Reykjavík Grapevine BestOff
## Introduction

This is the repo for the Reykjavik Grapevine Best Off iOS App.
The app is under active development, scheduled to be released in April/May 2019.

So far I've been experiencing with code generation of datamodels curtesy of http://www.jsoncafe.com/  

coupled with Swift's new Codable protocol, you can generate your data models easily by setting the  

generator to Swift Decodable 

The app is written in MVVM and uses ReactiveKit and Bond for databindings. 

## Setup
Xcode version 10  
Swift 4.2  
Cocoapods installed on your mac

`$ git clone https://github.com/ivarhuni/BestOff.git`


  `$ pod install`


 open BestOff.xcworkspace & press Run


## Code Comments 
Each ViewController binds to a datasource in it's viewmodel to display data  

Some VC.swift Example Code:  


 `func setupBindings(){  

 	....  

 	_ = viewModel.arrGuideCategory.bind(to: self){ me, array in  

            print("Detected new value for guide array")  

 	  }  

 	 ....  
 }`

This is an alternative way of writing
_ = viewModel.arrGuideCategory.observeNext{ [weak self] array in
guard let this = self else{ return }
print("Detected new value for guide array")
}.dispose(in: disposeBag)  

Here we don't have to dispose of the binding since it's bound to self
And hence deallocates with it when self is destroyed
And we dont have to worry about
threading, retain cycles and disposing because bindings take care of all that automatically




# Contact
   
   Author: Ívar Húni Jóhannesson


   email: ivarhuni89@gmail.com
