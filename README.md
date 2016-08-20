# Scraping Page Rank Script

===================

A work in progress as of August 2016.

This Ruby application tracks
  1) Visibility of Properties on Partner sites
  2) Page Ranking of Properties on Partner sites

For both components you will require an input file, which must be loaded into `properties/#{partner_name}/properties.csv`. The CSV should be formed as per the documentation in the +RmImporter+ class. See that class for details. The properties directory is gitignored.

Results will be output to `results/#{partner_name}/`. The results directory is gitignored. Any required directories will be will be created dynamically by fileutils once the script runs.

===================

### Usage:

```
require_relative 'scraper'

Report.generate

```

Or Optionally pass an array of partners to narrow down the scope of the report:

```
Report.generate(["your_partner"])
```

To narrow down the scope of the report to less cities for a given partner make the necessary amneds to  `config/cities.yml`.

===================

### Adding a new Partner:

1) Add the partner_name to `config/partners.yml`
2) Add the corresponding cities that you seek to crawl for the given partner to `config/cities.yml`
3) Manually import a file name `properties.csv` into `properties/#{partner_name}/`
4) Add a Client and Importer class under a namespace of your partner. (lib/#{partner_name}/client.rb etc.). Ensure you require these files in `scraper.rb`.
5) Add the necessary methods (namely `Client#url_builder` & `Importer#import`)
6) Run your report `Report.generate`


===================

### Outputs:

Currently the application is providing 4 outputs:
  1) Page Rank Graph - see class `PageRankGraph`
  2) Page Ranking (raw) data - see class `PageRankExporter`
  3) Summary - see class `Summarizer`
  4) Raw Output of the compared data - see class `RawExporter`

===================