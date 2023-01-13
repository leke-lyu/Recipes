<a name="readme-top"></a>
# Recipes
A detailed documentation of my scripts and customized data

<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#buildgisaiddatabaser">buildGISAIDdatabase.R</a>
      <ul>
        <li><a href="#description">Description</a></li>
      </ul>
      <ul>
        <li><a href="#usage">Usage</a></li>
      </ul>
    </li>
    <li>
      <a href="#generatenextstrainsamplesr">generateNextStrainSamples.R</a>
      <ul>
        <li><a href="#description-1">Description</a></li>
      </ul>
      <ul>
        <li><a href="#usage-1">Usage</a></li>
      </ul>
    </li>
  </ol>
</details>

## [buildGISAIDdatabase.R](https://github.com/leke-lyu/Recipes/blob/main/Scripts/buildGISAIDdatabase.R)

### Description

This script used RSQLite to build a local database indexing the metadata of all SARS-CoV-2 samples in GISAID. To use this script, the user needs to indicate the path to the `metadataFolder`. The `meta.db` is the expected result.

### Usage

```shell
Rscript buildGISAIDdatabase.R metadataFolder
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## [generateNextStrainSamples.R](https://github.com/leke-lyu/Recipes/blob/main/Scripts/generateNextStrainSamples.R)

### Description

This script used RSQLite to build a local database indexing the metadata of all SARS-CoV-2 samples in GISAID. To use this script, the user needs to indicate the path to the `metadataFolder`. The `meta.db` is the expected result.

### Usage

```shell
Rscript /Users/lekelyu/Desktop/generateNextStrainSamples.R /Users/lekelyu/Library/CloudStorage/OneDrive-UniversityofGeorgia/vendor/Texas_cumulative.csv /Users/lekelyu/Library/CloudStorage/OneDrive-UniversityofGeorgia/GISAID/meta.db /Users/lekelyu/Library/CloudStorage/OneDrive-UniversityofGeorgia/nextstrain 1000 400 100 100 100 100 100 100
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>


