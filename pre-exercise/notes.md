first install your infra and tools

for gitlab:
- dont forget to set gitlab_home env
- find initial password in container
- after login create a user
- edit user password
- create a project
- adjust network outbound rules for integration (if needed)


for jenkins:
- first of all install necessary plugins (ws-cleaner, pipeline, gitlab etc.)
- add your credentials one by one (dont forget docker hub)
- start to create pipelines, first dispatcher pipeline
- create webhook on gitlab to trigger pipeline