# Change Log
## Unreleased
### Added
* Include `:all_entries` option to `activate` block for getting over 1000 entries[#45](https://github.com/contentful-labs/contentful_middleman/issues/45)
* Update `middleman-core` required version
* Removes `middleman-blog` dependency[#9](https://github.com/contentful-labs/contentful_middleman/issues/9)

## 1.1.1
### Changed
* Breadth-first search of linked entries

## 1.1.0
### Added
* New extension option: `use_preview_api`
* An example mapper that allows references from linked to linking entries

### Changed
* Make the all the entries available inside the mapper

### Fixed
* Calculate the version hash using the `updated_at` value of every entry instead of its revision

## 1.0.4
### Fixed
* Typo in the require statements
* The importing of entries with fields containing a list of elements other that links to entries now works
* Handle non included links i.e. when the `include` query parameter is not present or its value doesn't cover a link

## 1.0.3
## Fixed
* The importing of entries including `Contentful::Location` fields now works


## 1.0.2
### Fixed
* Include `middleman-blog` as dependency of the gem.

## 1.0.1
### Fixed
* Set local data file extension to *.yaml*

## 1.0.0
### Other
This release brings breaking changes that are not compatible with extension configurations in
previous versions. For more information about the supported configuration please read the
README file.

Changes in this release:

* Support multiple activations of the extension. Import from multiple spaces
* Decouple mapping of entries from blog post layout. Support custom mappers
* Store imported entries as local data
* Optionally rebuild static site only when there are changes in the imported data

## 0.0.4
### Other
* Publish first Gem version

## 0.0.3

### Other
* Minor updates


## 0.0.2
### Other
* First release
