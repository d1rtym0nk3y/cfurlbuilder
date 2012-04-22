ColdFusion Url Builder
============

Create and modify URLs and URL parameters easily, with a builder class.

Simplified clone of [mikaelhg](https://github.com/mikaelhg/urlbuilder)'s java url builder for ColdFusion. 
Since we're almost always after a url represented as a string this class won't return a Url or Uri object, 
once your done constructing your url call toString() to return it.


Sample Usage
------------
Create a new url from scratch
```
myurl = new net.m0nk3y.urlbuilder.UrlBuilder()
            .withScheme("http")
            .withHost("google.com")
            .withPath("/")
            .addParam("q", "Foo Fighters")
            .toString();
```

Alter an existing url
```
mynewurl = new net.m0nk3y.urlbuilder.UrlBuilder()
            .fromString("http://example.com/foo/bar.html?abc=123")
            .withScheme("https") 
            .setParam("abc", 456)
            .toString();
```

