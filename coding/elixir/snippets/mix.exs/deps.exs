# The `consistency` alias runs all the styling tools at once.
#
# Add the following to your project configuration in mix.exs
#
# dialyzer: [
#     plt_add_apps: [:eex, :mix]
# ],
#   aliases: aliases()

[
  {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
  {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
  {:doctor, "~> 0.22", only: :dev, runtime: false},
  {:ex_doc, "~> 0.38", only: :dev, runtime: false}
]

defp aliases do
  [
    consistency: [
      "format",
      "compile --warnings-as-errors",
      "credo --strict",
      "dialyzer",
      "doctor"
    ]
  ]
end

# ## Dependencies
#
# * [Credo](https://hexdocs.pm/credo)
# * [Dialyxir](https://hexdocs.pm/dialyxir)
# * [Doctor](https://hexdocs.pm/doctor)
# * [ExDoc](https://hexdocs.pm/ex_doc)
