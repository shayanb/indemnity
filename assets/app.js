let defaultAccount, contractAbi

const address = '0xfb228adfe863a36538516ce2a97361324102b237'

let plots = []
let requests = []

function submitRequest() {
  const plotId = document.getElementById('plotIdValue').value
  const startDate = new Date(document.getElementById('startDate').value).getTime()
  const endDate = new Date(document.getElementById('endDate').value).getTime()
  const premium = document.getElementById('premium').value
  const cover = document.getElementById('cover').value

  const contract = new web3.eth.Contract(contractAbi, address)

  contract.methods.submitInsuranceRequest(plotId, startDate, endDate, premium, cover).send({ from: defaultAccount }, (error, result) => {
    console.log('%cRESULT:', 'color:teal', result)
    document.getElementById('loader').style.display = 'block'
  })
}

function addPlot() {
  const plotName = document.getElementById('plotname').value
  const plotAddress = document.getElementById('plotaddress').value

  const contract = new web3.eth.Contract(contractAbi, address)

  contract.methods.addPlot(plotName, plotAddress).send({ from: defaultAccount }, (error, result) => {
    document.getElementById('loader').style.display = 'block'
  })
}

/**
 * Sets all up the listeners for the contracts events.
 */
function createEventLogListeners(abi) {
  const contract = new web3.eth.Contract(abi, address)

  const tbody = document.querySelector('tbody')

  var options = { year: 'numeric', month: 'long', day: 'numeric' }

  contract.events.InsuranceRequestSubmitted({ fromBlock: 0, toBlock: 'latest' }, (error, event) => {
    const data = event.returnValues

    const requestExists = requests.filter(request => request == data[0])

    if (requestExists.length) {
      return
    }

    requests.push(data[0])

    const plotName = plots.find(plot => plot.id == data[1])

    tbody.innerHTML += `<tr>
      <td class="mdl-data-table__cell--non-numeric">${plotName ? plotName.name : 'no name'}</td>
      <td class="mdl-data-table__cell--non-numeric">${new Date(Number(data[3])).toLocaleString('en-US', options)}</td>
      <td class="mdl-data-table__cell--non-numeric">${new Date(Number(data[4])).toLocaleString('en-US', options)}</td>
      <td>${Number(data[5]).toLocaleString('en-US', { style: 'currency', currency: 'USD' })}</td>
      <td>${Number(data[6]).toLocaleString('en-US', { style: 'currency', currency: 'USD' })}</td>
      <td>
        <button class="mdl-button mdl-js-button mdl-button--primary">Accept</button>
        <button class="mdl-button mdl-js-button mdl-button--accent" style="color:red">Cancel</button>
      </td>
    </tr>`

    document.getElementById('loader').style.display = 'none'
  })

  contract.events.PlotAdded({ fromBlock: 0, toBlock: 'latest' }, (error, event) => {
    const data = event.returnValues

    const plotExists = plots.filter(plot => plot.id == data[1])

    if (plotExists.length) {
      return
    }

    plots.push({ id: data[1], name: data[0] })

    document.getElementById('loader').style.display = 'none'
    document.getElementById('plotlist').innerHTML += `<li class="mdl-menu__item" data-val="${data[1]}">${data[0]}</li>`

    getmdlSelect.init('.getmdl-select')
  })
}

/**
 * Invoked once the selected accounts (ethereum address) has been resolved.
 * Fetches the abi for the both crop insurance contract.
 *
 * @param {Object} error The error object if an error occurred, otherwise null.
 * @param {array} accounts Collection of string addresses of the users accounts.
 */
function getAccountsAndContracts(error, accounts) {
  if (!accounts.length) {
    console.log('No accounts detected!')

    return
  }

  defaultAccount = accounts[0]

  console.log('default account: ' + defaultAccount)

  fetch('assets/abi.json?random=' + Date.now())
    .then(response => response.json())
    .then(abi => (contractAbi = abi))
    .then(createEventLogListeners)
}

/**
 * Bootstraps the injected web3 provider from Metamask or dapp browser.
 */
function initApp() {
  if (window.ethereum) {
    window.web3 = new Web3(ethereum)

    console.log('ethereum available')

    try {
      ethereum.enable().then(() => {
        console.log('ethereum enabled, getting accounts...')
        web3.eth.getAccounts(getAccountsAndContracts)
      })
    } catch (error) {
      console.error('Unable to load Ethereum account as request was denied by user', error)
      console.log('Unable to load Ethereum account as request was denied by user')
    }
  } else if (window.web3) {
    window.web3 = new Web3(web3.currentProvider)

    console.log('Ethereum not available, attempting to get accounts anyway...')

    web3.eth.getAccounts(getAccountsAndContracts)
  } else {
    console.log('Not a web3 enabled browser!')
  }
}

window.addEventListener('load', initApp)
