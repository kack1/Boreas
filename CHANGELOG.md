# Revision history for boreas
## 0.1.0 -- 2024-02-12
* Added GitHub CI - via haskell-ci
* Added porcelain commands
	- run 	: Creats accounts, scrapes keys, and gives access.
	- update: Scrapes keys, updates access.
	- pruge : Deletes accounts, removes access. 

## 0.0.2 -- 2024-01-22

* Marked as the "Minimum Viable Product" and only works on Unix-like systems
* Boreas can take in a configuration file as the only parameter
* Uses config file to scrape Github for SSH public keys
* Uses config file to create accounts
* Uses scraped SSH keys to insert them into authorized keys file of a given user

