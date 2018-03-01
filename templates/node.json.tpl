{
  "qbroker": {
    "repo_url": "${qbroker_repo_url}"
  },
  "run_list": [
    "recipe[common::default]",
    "recipe[${wrapper_cookbook}::${recipe}]"
  ]
}
