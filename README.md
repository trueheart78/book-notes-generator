# Book Notes Generator :boom:

Companion to [Book Notes](https://github.com/trueheart78/book-notes)

1. [Outstanding Tasks](#outstanding-tasks)
1. [Development](#development)
1. [Adding a Book](#adding-a-book)
   1. [Configuration](#configuration)
   1. [Creating YAML For a Book](#creating-yaml-for-a-book)
   1. [Importing a book](#importing-a-book)
   1. [Sample Book YAML](#sample-book-yaml)
   1. [Sample Output](#sample-output)


## Outstanding Tasks

- Write tests for the Import Controller
- Write tests for the Notes Generator

## Development

Make sure bundler is installed, and then run `bundle install`.

Tests can be run with `bundle exec rake test`. Tests are written using Minitest.

## Adding a Book

### Configuration

Make a local copy of the `config.default` file:

```sh
cp config.default config.local
```

Edit `config.local` with a full path for `book_notes_path`, the proper
`yaml_directory`, and the `notes_directory`. Leaving either of the directories
blank is allowed, and for the `notes_directory`, likely desired.

### Creating YAML For a Book

Books can be added by creating a `book-name.yml` file in the `yaml_directory`
location defined in the config file.

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

An empty section name is seen as `nil`, and will not cause a section title to
be written out.

```yaml
---
:title: An Awesome Book
:purchase: http://buyonline.example.com
:author: That One Girl
:homepage: http://www.thatonegirl.com/
:image: https://image.example.com/an-awesome-book/
:image_ext: jpg

:sections:
  -
    :name:
    :chapters:
    - The Intro Chapter
  -
    :name: Part 1. Kicking Butt
    :chapters:
    - The Second Chapter
    - The Third Chapter
  -
    :name: Part 2. Taking Names
    :chapters:
    - The Fourth Chapter
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
- Chapters: 5
   01. The Intro Chapter - ch01-the-intro-chapter.md
   Part 1. Kicking Butt
     02. The Second Chapter - ch02-the-second-chapter.md
     03. The Third Chapter - ch03-the-third-chapter.md
   Part 2. Taking Names
     04. The Fourth Chapter - ch04-the-fourth-chapter.md
     05. In Closing - ch05-in-closing.md
---------------------
Import 'An Awesome Book' by That One Girl :: 5 chapters? (y/n)
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
