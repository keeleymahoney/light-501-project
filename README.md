<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a id="readme-top"></a>
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
<!--[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url] -->



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/keeleymahoney/light-501-project">
    <img src="images/BOLD_Logo.jpg" alt="Logo" width="100" height="100">
  </a>

<h3 align="center">light-501-project</h3>

  <p align="center">
    A website hub for TAMU Business Outreach for Leadership and Diversity.
    <br />
    <a href="https://docs.google.com/document/d/1dydC-EhVsld7Jy1-cPp65oN60rj1JVaswKlvAFBuMbo/edit?usp=sharing"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/keeleymahoney/light-501-project">View Demo</a>
    ·
    <a href="https://github.com/keeleymahoney/light-501-project/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    ·
    <a href="https://github.com/keeleymahoney/light-501-project/issues/new?labels=enhancement&template=feature-request---.md">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#deployment">Deployment</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

[![Product Name Screen Shot][product-screenshot]](https://example.com)

This project aims to create a functional website for the TAMU organization BOLD (Business Outreach for Leadership and Diversity). The site will allow admins to manage events, members, and contacts in the network accessible to members. It will allow members and general users a place to find information about the organization and its events. And it will allow specific members access to the network of business contacts that BOLD has access to and to submit requests to join that network themselves. 

<p align="right">(<a href="#readme-top">back to top</a>)</p>



### Built With

* [![Ruby][Ruby.com]][Ruby-url]
* [![Rails][Rails.org]][Rails-url]
* [![OAuth][OAuth.com]][OAuth-url]
* [![Forms][Forms.com]][Forms-url]
* [![Docker][Docker.com]][Docker-url]
* [![Heroku][Heroku.com]][Heroku-url]
* [![Bootstrap][Bootstrap.com]][Bootstrap-url]
* [![Postgresql][Postgresql.org]][Postgresql-url]
* [![Rubocop][Rubocop.org]][Rubocop-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->

## Getting Started

This project 

### Prerequisites

There are some external dependencies that this project makes use of and need to be installed/setup to get working
* Docker - Download latest version at https://www.docker.com/products/docker-desktop
* Heroku CLI - Download latest version at https://devcenter.heroku.com/articles/heroku-cli
* Git - Downloat latest version at https://git-scm.com/book/en/v2/Getting-Started-Installing-Git

### Installation

1. Set up Directory
    ```sh
   mkdir light-501-project
   cd light-501-project
   ```

1. Download this code repository by using git:
    ```sh
    git clone git@github.com:keeleymahoney/light-501-project.git
    ```
    or 
    ```sh
    git clone https://github.com/keeleymahoney/light-501-project.git
    ```

2. Set up Docker Image
   ```sh
   docker run -it --volume "${PWD}:/light-501-project" -e DATABASE_USER=test_app -e DATABASE_PASSWORD=test_password -p 3000:3000 paulinewade/csce431:latest
   ```
3. Now, inside of the container, move to the app directory
   ```sh
   cd light-501-project
   ```
4. Install Gems and Set up Database
   ```sh
   bundle install
   rails db:create
   rails db:migrate
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Usage

To run the app locally run the following command in the docker container, in the `light-501-project` directory:
  ```sh
   rails server --binding=0.0.0.0
   ```
<p>Then open up <a href="http://localhost:3000">http://localhost:3000</a></p>

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- Deployment -->
## Deployment

Deployment on Heroku

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- ROADMAP -->
## Roadmap

- [x] Event Creation
    - [x] Forms Generation
- [x] Network Creation
- [ ] Member Sign-In
- [ ] Landing Page
- [ ] User Navigation, about page, and photo gallary

See the [open issues](https://github.com/keeleymahoney/light-501-project/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>


### Top contributors:

<a href="https://github.com/keeleymahoney/light-501-project/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=keeleymahoney/light-501-project" alt="contrib.rocks image" />
</a>


<!-- CONTACT -->
## Contact

Please contact Pauline Wade at paulinewade@tamu.edu for any issues or concerns regarding this project. 

Project Link: [https://github.com/keeleymahoney/light-501-project](https://github.com/keeleymahoney/light-501-project)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* [README Template](https://github.com/othneildrew/Best-README-Template)


<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/keeleymahoney/light-501-project.svg?style=for-the-badge
[contributors-url]: https://github.com/keeleymahoney/light-501-project/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/keeleymahoney/light-501-project.svg?style=for-the-badge
[forks-url]: https://github.com/keeleymahoney/light-501-project/network/members
[stars-shield]: https://img.shields.io/github/stars/keeleymahoney/light-501-project.svg?style=for-the-badge
[stars-url]: https://github.com/keeleymahoney/light-501-project/stargazers
[issues-shield]: https://img.shields.io/github/issues/keeleymahoney/light-501-project.svg?style=for-the-badge
[issues-url]: https://github.com/keeleymahoney/light-501-project/issues
[license-shield]: https://img.shields.io/github/license/keeleymahoney/light-501-project.svg?style=for-the-badge
[license-url]: https://github.com/keeleymahoney/light-501-project/blob/master/LICENSE.txt
[Bootstrap.com]: https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white
[Bootstrap-url]: https://getbootstrap.com
[Rails-url]: https://rubyonrails.org/
[Rails.org]: https://img.shields.io/badge/Rails-D30001?style=for-the-badge&logo=rubyonrails&logoColor=white
[Ruby-url]: https://www.ruby-lang.org/en/
[Ruby.com]: https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[OAuth-url]: https://developers.google.com/identity/protocols/oauth2
[OAuth.com]: https://img.shields.io/badge/Google-OAuth-4285F4?style=for-the-badge&logo=googleauthenticator&logoColor=white
[Forms-url]: https://developers.google.com/forms/api/reference/rest
[Forms.com]: https://img.shields.io/badge/Google-Forms-7248B9?style=for-the-badge&logo=googleforms&logoColor=white
[Docker-url]: https://www.docker.com/
[Docker.com]: https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white
[Heroku-url]: https://www.heroku.com/platform
[Heroku.com]: https://img.shields.io/badge/Heroku-430098?style=for-the-badge&logo=heroku&logoColor=white
[Postgresql-url]: https://www.postgresql.org/
[Postgresql.org]: https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white
[Rubocop-url]: https://rubocop.org/
[Rubocop.org]: https://img.shields.io/badge/RuboCop-000000?style=for-the-badge&logo=rubocop&logoColor=white
