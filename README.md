# tellstick-client-haxe
A Haxe implementation of a tellstick remote server client.

# Tellstick what?
A tellstick is a device you can use to control other stuff in your home, such as lights, electrical outlets and it can also receive data from sensors, such as home weather stations.

Using the client requires using the remotestick server: https://github.com/jorilytter/remotestick-server

If you're curious about how all this is set up, read up on it here: http://polarcoder.blogspot.fi/2015/10/diy-home-automation-v1.html (there's also part 2 if you're interested in tuning it further)

# What is this then?
It's an alternative to the tellstick server web pages. It can be compiled to native applications for the android and ios devices. Native apps start much faster than a browser and then directing that browser to a web page.

# How to set up the compilation.
1. clone or download this repo
2. Install Haxe from http://haxe.org

I've tried installing haxe with homebrew on my mac and it always ends up in a weird state, so I recommend installing it from the installer or the binaries on the haxe site. I trust you're able to do that on your operating system.

3. run `haxelib setup` from the terminal and select a path where haxe can download it's libraries
4. `haxelib install lime`
5. `haxelib run lime setup` (I recommend you install the lime command)
6. `haxelib install flixel`
7. `haxelib install rest-client`
8. Make one of the builds, for example: `lime build cpp` (build native OS application, will take a while the first time) or perhaps `lime build html5` to make a javascript build to run in the browser.

Making a native ios app requires xcode and apple dev licence. Making an android build requires android devkit.

