# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
MaMairie::Application.config.secret_token = ENV['SECRET_TOKEN'] || '1272709f0886612aa2f8d8e126701af32224d3df4202ece17bd2b281e0b5dff9b2b6257d53a5b23b9bd094b9a26c6629efbe51f7fae662944e479493d208bec7'
