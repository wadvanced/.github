# Add the following to your project configuration in mix.exs
#
# dialyzer: [
#   plt_core_path: "priv/plts",
#   plt_file: {:no_warn, "priv/plts/core.plt"}
# ]

[
  {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
  {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
  {:doctor, "~> 0.22", only: :dev, runtime: false},
  {:ex_doc, "~> 0.38", only: :dev, runtime: false}
]

# ## Dependencies
#
# * [Credo](https://hexdocs.pm/credo)
# * [Dialyxir](https://hexdocs.pm/dialyxir)
# * [Doctor](https://hexdocs.pm/doctor)
# * [ExDoc](https://hexdocs.pm/ex_doc)
