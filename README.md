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
      <a href="#colorpalettefornextstrainr">colorPaletteForNextStrain.R</a>
      <ul>
        <li><a href="#description-1">Description</a></li>
      </ul>
      <ul>
        <li><a href="#usage-1">Usage</a></li>
      </ul>
    </li>
    <li>
      <a href="#covidintexasdataprocessingr">covidInTexasDataProcessing.R</a>
      <ul>
        <li><a href="#description-2">Description</a></li>
      </ul>
      <ul>
        <li><a href="#usage-2">Usage</a></li>
      </ul>
    </li>
    <li>
      <a href="#editmetaofnextstrainsamplesr">editMetaOfNextStrainSamples.R</a>
      <ul>
        <li><a href="#description-3">Description</a></li>
      </ul>
      <ul>
        <li><a href="#usage-3">Usage</a></li>
      </ul>
    </li>
    <li>
      <a href="#generatenextstrainsamplesr">generateNextStrainSamples.R</a>
      <ul>
        <li><a href="#description-4">Description</a></li>
      </ul>
      <ul>
        <li><a href="#usage-4">Usage</a></li>
      </ul>
    </li>
     <li>
      <a href="#samplingdatedistributionr">samplingDateDistribution.R</a>
      <ul>
        <li><a href="#description-5">Description</a></li>
      </ul>
      <ul>
        <li><a href="#usage-5">Usage</a></li>
      </ul>
    </li>
  </ol>
</details>

## [buildGISAIDdatabase.R](https://github.com/leke-lyu/Recipes/blob/main/Scripts/buildGISAIDdatabase.R)

### Description

This script used RSQLite to build a local database indexing the metadata of all SARS-CoV-2 samples in [GISAID](https://gisaid.org). To use this script, the user needs to indicate the path to the `metadataFolder`. The `meta.db` is the expected result.

### Usage

```shell
Rscript buildGISAIDdatabase.R metadataFolder
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## [colorPaletteForNextStrain.R](https://github.com/leke-lyu/Recipes/blob/main/Scripts/colorPaletteForNextStrain.R)

### Description

Adding Custom Trait Colors.

### Usage

```shell
Rscript colorPaletteForNextStrain.R pathToNextStrainMeta workingDirectory
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## [covidInTexasDataProcessing.R](https://github.com/leke-lyu/Recipes/blob/main/Scripts/covidInTexasDataProcessing.R)

### Description

Processing HHD meta data.

### Usage

```shell
Rscript covidInTexasDataProcessing.R pathToTexas_cumulative.csv pathToMeta.db workingDirectory
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## [editMetaOfNextStrainSamples.R](https://github.com/leke-lyu/Recipes/blob/main/Scripts/editMetaOfNextStrainSamples.R)

### Description

The script modified the meta file downloaded from [GISAID](https://gisaid.org).

### Usage

```shell
Rscript editMetaOfNextStrainSamples.R pathToTexas_cumulative.csv pathToNextStrainMeta
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## [generateNextStrainSamples.R](https://github.com/leke-lyu/Recipes/blob/main/Scripts/generateNextStrainSamples.R)

### Description

This script was designed to generate a sample list. The `seq.list` is a guide file to download samples from [GISAID](https://gisaid.org). To run this script, 11 arguments must be supplied.

### Usage

```shell
Rscript generateNextStrainSamples.R pathToTexas_cumulative.csv pathToMeta.db workingDirectory numOfTexasSamples numOfUSASamples numOfNorthAmericaSamples numOfAfricaSamples numOfAsiaSamples numOfEuropeSamples numOfOceaniaSamples numOfSouthAmericaSamples
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## [samplingDateDistribution.R](https://github.com/leke-lyu/Recipes/blob/main/Scripts/samplingDateDistribution.R)

### Description

Given a meta table, this script plot the distribution of sampling date.

### Usage

```shell
Rscript samplingDateDistribution.R pathToMeta workingDirectory limitMin limitMax
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>
