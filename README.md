# Book Notes Generator :boom:

Companion to [Book Notes](https://github.com/trueheart78/book-notes)

## Todo

- Wrap tests around untested code
- Update this README with better instructions

## Adding a Book

### Config

Make a local copy of the `config.default` file:

```sh
cp config.default config.development
```

Edit `config.development` with a full path for `book_notes_path`, the proper `yaml_directory`,
and the `notes_directory`. Leaving either of the directories blank is allowed, and for the
`notes_directory`, likely desired.

### Creating YAML for a Book

Books can be added by creating a `book-name.yml` file in the input directory
defined in the config file.

You can create the YAML file by running:

```sh
./generate -c book-name
```

### Importing a Book

To generate the proper note structure for a new book, run:

```sh
./generate book-name
```

And follow the prompts.

## Sample Book YAML

```yaml
---
:title: An Awesome Book
:purchase: http://buyonline.example.com
:author: That One Girl
:homepage: http://www.thatonegirl.com/
:image: https://image.example.com/an-awesome-book/
:image_ext: jpg

:chapters:
  - The First Chapter
  - The Second Chapter
  - The Third Chapter
  - In Closing
```

## Sample Output

After you save the above as `yaml/sample-book.yml`, and
run `./generate sample-book`, you should see the following:

```
- Directory: an-awesome-book
- Title: An Awesome Book
- Purchase: http://buyonline.example.com
- Author: That One Girl
- Homepage: http://www.thatonegirl.com/
- Image? true [jpg]
   https://image.example.com/an-awesome-book/
- Chapters: 4
   01. The First Chapter - ch01-the-first-chapter.md
   02. The Second Chapter - ch02-the-second-chapter.md
   03. The Third Chapter - ch03-the-third-chapter.md
   04. In Closing - ch04-in-closing.md
---------------------
Import 'An Awesome Book' by That One Girl :: 4 chapters? (y/n)
```

Entering `y` will generate the proper files in the noted directory,
download the image (if it is valid), and inform you of this task:

```sh
**********************************************************************

Please add the following to the root book-notes README.md file:

1. [An Awesome Book](an-awesome-book/README.md)

**********************************************************************

Book notes generated successfully.
```

## Development

Make sure bundler is installed, and then run `bundle install`.

Tests can be run with `bundle exec rake test`. Tests are written using Minitest.
