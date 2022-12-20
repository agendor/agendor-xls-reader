# Agendor FastXlsxReader

Agendor FastXlsxReader is a simple high performance GEM for reading Microsoft Excel files with low footprint. 
Uses [XLSX/IO](https://brechtsanders.github.io/xlsxio/) as the base of the native extension.

## Dependencies

FastXlsxReader needs some native dependencies to compile the extension, they are:

- A C compiler;
- GNU Make;
- Minizip;

## Installation

Before installing the GEM, install the native dependencies on your operating system.

### Debian based
```shell
apt-get install -y libminizip-dev build-essential
```

### RHEL (Red Hat/CentOS/Alma Linux/Rocky Linux/Oracle Linux)
```shell
yum groupinstall 'Development Tools'
yum install minizip-devel
```

### OpenSuse
```shell
zypper install -t pattern devel_basis
zypper install minizip-devel
```

### Alpine
```shell
apk add alpine-sdk
apk add minizip-dev
```

Now just reference the library in your Gemfile:

```ruby
gem 'fast_xlsx_reader'
```

And then execute:
```shell
bundle
```

Or install it yourself as:
```shell
gem install fast_xlsx_reader
```

## Usage

FastXlsxReader has only one class (Reader) with only three methods:

### Constructor
Receives the path of the file to be opened. If the file does not exist, it will throw a "TypeError" exception.

```ruby
reader = FastXlsxReader::Reader.new("my_spreadsheet.xlsx")
```

### each
The each method scans the first sheet of the file and calls the iteration block for each row. For each line, an array of
strings is passed to the block with all cell values.
```ruby
reader.each do |row|
  puts "Cells: #{row.join(", ")}"
end
```

### file_name
Method that returns the name of the file that was passed in the constructor. It's just a getter :-)
###

### Full example
```ruby
reader = FastXlsxReader::Reader.new("my_spreadsheet.xlsx")
reader.each do |row|
  puts "Cells: #{row.join(", ")}"
end
```
And that's it.

## Development

After checking out the repo, run `docker-compose build dev` to build a base image with all dependencies.

To run tests, use `docker-compose run tests`.
To run tests with coverage, use `docker-compose run coverage`.
To build the GEM use `docker-compose run build`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/agendor/agendor-xls-reader. 
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the 
[Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FastXlsxReader project’s codebases, issue trackers, chat rooms and mailing lists is expected 
to follow the [code of conduct](https://github.com/[USERNAME]/fast_xlsxreader/blob/master/CODE_OF_CONDUCT.md).
