# asi -- App Store Info from the Terminal #

[A]pp [S]tore [I]nfo is a zsh shell script for getting information about iOS and Mac apps from their respective app stores.

## Purpose ##

I created this script because I often want to pull out certain information about an app without loading its entire web page. For example, if I just want to quickly check the price of an app, I would rather drop into Terminal than load the page in Safari.

Also, this allows me to pull in information that I need/want in different scripts. It's nowhere near an "API for the App Store" but it works well enough for my needs.

## Requires ##

* [lynx](http://lynx.browser.org)
* [html2text.py](https://github.com/aaronsw/html2text/)
* user must set **tidy-basic-clean-reformat.rc** (included) as tidy's RC file by editing this line in the `asi.sh` script:

	HTML_TIDY="$HOME/Dropbox/etc/tidy/basic-clean-reformat.rc"

The script will not run without `lynx` and `html2text.py` installed.

If HTML_TIDY is not set properly, the script will run, but fail horribly.

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

## Bugs ##

1) While the user can use more than one of the above arguments, those arguments ***much each be separate.***

For example, if you want to see *just* the price and the rating(s), this will work:

	asi.sh -p -r 'http://itunes.apple.com/us/app/quickcursor/id404035899?mt=12'

but ***this will not:***

	asi.sh -pr 'http://itunes.apple.com/us/app/quickcursor/id404035899?mt=12'

despite the fact that any Van Hœt worth his neckbeard will tell you that it should.

*The fix is left as an exercise for the reader.*

2) This script has not been rigorously tested; therefore, the user should not consider it an accomplishment to find that it does not work in some situations. However, please do let me know if you find that it does not work, and include the URL(s) that you were attempting to use. In particular, the script was initially tested against the Mac App Store, and was later found to happen to work in the iOS App Store too, but there may be more cases where the script fails when checking apps in the iOS App Store.

3) The script will only work if you feed it URLs to the English version of the App Store. Obviously there are many other languages out there, but I built this to suit my needs. Please feel free to fork it and make it useful in your native language.

