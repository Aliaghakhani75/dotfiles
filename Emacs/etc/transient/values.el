((magit-fetch "--prune")
 (magit-log "-n256" "--follow" "--topo-order" "--graph" "--color" "--decorate")
 (magit-merge "--no-ff")
 (magit-rebase "--autostash")
 (magit-show-refs "--sort=-committerdate")
 (magit-tag "--annotate")
 (python-pytest-dispatch "--color" "--verbose --verbose" "--maxfail=10"))
