# asi #

[A]pp [S]tore [I]nfo - a shell script for getting information about iOS and Mac apps from their respective stores

## Requires ##


* [lynx](http://lynx.browser.org)
* [html2text.py](https://github.com/aaronsw/html2text/)
* user must set **tidy-basic-clean-reformat.rc** (included) as tidy's RC file by editing this line in the `asi.sh` script:

	HTML_TIDY="$HOME/Dropbox/etc/tidy/basic-clean-reformat.rc"

## Usage & Features ##

asi.sh requires only one argument, an URL to the Mac App Store or the iOS App Store:

	asi.sh <URL>

for example:

	asi.sh 'https://itunes.apple.com/us/app/waze-social-gps-traffic-gas/id323229106?mt=8'

or

	asi.sh 'http://itunes.apple.com/us/app/quickcursor/id404035899?mt=12'

By default, `asi.sh` will show the user all the information that it can find about the given URL. However, the user can limit the output to only certain types of information by giving additional arguments before the URL.

Here is a list of all of the available arguments:

-n, --name
: Official name of the app (note: this is always shown, regardless of whether it was specifically requested or not. Use this argument if *all you want* is the name of the app)

-d,	--description
: Full description of the app as entered by the developer

-D, --developer
: Show the developer name (might be individual or a company)

-i, --icon
: Show the URL to the app's image from the app store (Note: this is usually very high resolution)

-$,-p, --price
: Price of the app (including 'Free' where applicable)

-r, --rating
: Rating of the app, including both Current Version and All Versions, as available

-R, --requirements
: Show the hardware and/or OS requirements for the app

-s, --size
: Size of the app (how many MB/GB is it)

-u, --url
: Show the 'canonical' URL for the app (useful for when someone gives you a 'shortened' version or one that loops through 5 different referral URLs or contains other cruft)
	
Note that most of the longer arguments can be shortened, i.e. if you use `--dev` instead of `--developer` it will understand what you mean as long as you include the first 3-4 letters after the `--`. This is due to the fact that I am lazy and a terrible typist.

