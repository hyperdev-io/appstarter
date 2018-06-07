# testx-html-reporter
[![npm version](https://badge.fury.io/js/testx-html-reporter.svg)](http://badge.fury.io/js/testx-html-reporter)

HTML and screenshot reporter for *testx*.

This work is heavily based on [Protractor Jasmine 2 HTML Reporter](https://github.com/Kenzitron/protractor-jasmine2-html-reporter.git).

## Usage
In your Protractor configuration file, register testx-html-reporter:

<pre><code>var HtmlReporter = require('testx-html-reporter');

exports.config = {
   // ...
   onPrepare: function() {
      jasmine.getEnv().addReporter(
        new HtmlReporter({
          savePath: 'target/screenshots/'
        })
      );
   }
}</code></pre>

## Options
### Destination folder

Output directory for created files. All screenshots and reports will be stored here.

If the directory doesn't exist, it will be created automatically or otherwise cleaned before running the test suite.

<pre><code>jasmine.getEnv().addReporter(new HtmlReporter({
   savePath: './test/reports/'
}));</code></pre>

Default folder: <code>./</code>

### Show passed specs (optional)

By default the passed specifications will not be included in the report. To include them do:

<pre><code>jasmine.getEnv().addReporter(new HtmlReporter({
   showPassed: true
}));</code></pre>

Default value: <code>false</code>

### Show skipped count (optional)

By default the number of skipped specifications will not be included in the report. To include it do:

<pre><code>jasmine.getEnv().addReporter(new HtmlReporter({
   showSkippedCount: true
}));</code></pre>

Default value: <code>false</code>

### Show stack trace (optional)

By default the stacktrace of failed assertions will not be included in the report. To include it do:

<pre><code>jasmine.getEnv().addReporter(new HtmlReporter({
   showStacktrace: true
}));</code></pre>

Default value: <code>false</code>

### Screenshots folder (optional)

By default the screenshots are stored in a folder inside the default path

If the directory doesn't exist, it will be created automatically or otherwise cleaned before running the test suite.

<pre><code>jasmine.getEnv().addReporter(new HtmlReporter({
   savePath: './test/reports/',
   screenshotsFolder: 'images'
}));</code></pre>

Default folder: <code>screenshots</code>

### Take screenshots (optional)

When this option is enabled, reporter will create screenshots for specs.

<pre><code>jasmine.getEnv().addReporter(new HtmlReporter({
   takeScreenshots: false
}));</code></pre>

Default is <code>true</code>

### Take screenshots only on failure (optional) - (NEW)

This option allows you to choose if create screenshots always or only when failures.
If you disable screenshots, obviously this option will not be taken into account.

<pre><code>jasmine.getEnv().addReporter(new HtmlReporter({
   takeScreenshots: true,
   takeScreenshotsOnlyOnFailures: true
}));</code></pre>

Default is <code>false</code> (So screenshots are always generated)

### FilePrefix (optional)

Filename for html report.

<pre><code>jasmine.getEnv().addReporter(new HtmlReporter({
   savePath: './test/reports/',
   filePrefix: 'index'
}));</code></pre>

Default is <code>htmlReport.html</code>

### Consolidate and ConsolidateAll (optional)

This option allow you to create diferent HTML for each test suite.

<pre><code>jasmine.getEnv().addReporter(new HtmlReporter({
   consolidate: true,
   consolidateAll: true
}));</code></pre>

Default is <code>false</code>
