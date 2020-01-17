# R. Alexander Miłowski's Journal

This repository contains the source to my web journal.  All the content is licensed under the [Creative Commons Attribution 4.0 International](https://creativecommons.org/licenses/by/4.0/) license. Enjoy!

## Source Format

The content for my blog is written in a YAML+Markdown based format (see [yablog](https://github.com/alexmilowski/yablog)). Maybe you think I'm a bit loony but it works for me quite well.

## gh-pages (Github Pages)

I use the gh-pages branch to publish to Github Pages. Then I can use the public
facing github.io website (i.e., `http://alexmilowski.github.io/milowski-journal`) to
pull the post-processed content for various purposes. Typically, I pull that
content (live or cached) into another system to produce my website's blog.

## Post Processing

The process is rather straight forward assuming you've setup a gh-pages branch
and followed [Github's instructions](https://pages.github.com) to setup the
Github Pages hosting.

If you are curious, the process to publish is as follows:

1. Pull both branches:

   ```bash
   git clone https://github.com/alexmilowski/milowski-journal.git
   mkdir gh-pages
   cd gh-pages
   git clone https://github.com/alexmilowski/milowski-journal.git
   git checkout gh-pages
   cd ..
   ```

1. Process the source content (there are many variations to this):

   ```bash
   python -m yablog -w http://www.milowski.com/journal/entry/ -e http://alexmilowski.github.io/milowski-journal/ -o gh-pages/milowski-journal milowski-journal/entries --html
   ```

   In the above, we are producing the HTML output in `gh-pages/milowski-journal`
   from the source content in `milowski-journal/entries`. The `-w` option
   controls the URI of the resulting resource (e.g., the blog entry URL on my
   website) and the `-e` option controls the resource location to retrieve
   the resource content (e.g., the HTML content on GitHub Pages).

   This command also copies all artifacts (e.g., images) to the `gh-pages`
   target so your artifacts for the article are also hosted on gh-pages.

1. Commit and push the changes to the `gh-pages` branch:

   ```bash
   cd gh-pages/milowski-journal
   git add -A
   git commit -m "new entry - yay"
   git push
   ```

Everything is then live shortly there after.
