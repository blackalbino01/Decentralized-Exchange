const Web3 = require("web3")

if (window.ethereum != null) {
  state.web3 = new Web3(window.ethereum)
  try {
    // Request account access if needed
    await window.ethereum.enable()
    // Acccounts now exposed
  } catch (error) {
    // User denied account access...
  }
}
