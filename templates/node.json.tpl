{
  "common": {
    "swap_size": "${swap_size}"
  },
  "qbroker": {
    "repo_url": "${qbroker_repo_url}"
  },
  "run_list": [
    "recipe[common::default]",
    "recipe[${cookbook}::${recipe}]"
  ]
}
