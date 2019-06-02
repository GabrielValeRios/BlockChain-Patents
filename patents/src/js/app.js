App = {
  web3Provider: null,
  contracts: {},

  init: async function() {

    return await App.initWeb3();
  },

  initWeb3: async function() {
    // Modern dapp browsers...
    if (window.ethereum) {

      App.web3Provider = window.ethereum;

      try {
        // Request account access
        await window.ethereum.enable();
      
      } catch (error) {
        // User denied account access...
        console.error("User denied account access")
      }
    }
    
    // Legacy dapp browsers...
    else if (window.web3) {
      App.web3Provider = window.web3.currentProvider;
    }
    
    // If no injected web3 instance is detected, fall back to Ganache
    else {
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }

    web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function() {
    $.getJSON('Patents.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract
      var PatentsArtifact = data;
      App.contracts.Patent = TruffleContract(PatentsArtifact);

      // Set the provider for our contract
      App.contracts.Patent.setProvider(App.web3Provider);

      // Use our contract to retrieve and mark the adopted pets
    });
  },

  deployPatent: function() {
    var contract = document.getElementById("patent_input").value;
    console.log(contract)
    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];

      App.contracts.Patent.deployed().then(function(instance) {
        patentInstance = instance;
        patentInstance.declarePatent(contract, {from: account});
      }).catch(function(err) {
        console.log(err.message);
      });
    });   
  },

  // bindEvents: function() {
  //   $(document).on('click', '.btn-adopt', App.handleAdopt);
  // },

  getPatents: function(adopters, account) {
    var patentInstance;

    App.contracts.Patent.deployed().then(function(instance) {
      patentInstance = instance;

      return patentInstance.getOwnerPatents.call();
    }).then(function(patents) {
      for (i = 0; i < adopters.length; i++) {
        if (adopters[i] !== '0x0000000000000000000000000000000000000000') {
          $('.panel-pet').eq(i).find('button').text('Success').attr('disabled', true);
        }
      }
    }).catch(function(err) {
      console.log(err.message);
    });
  },

  // handleAdopt: function(event) {
  //   event.preventDefault();

  //   var petId = parseInt($(event.target).data('id'));

  //   var adoptionInstance;

  //   web3.eth.getAccounts(function(error, accounts) {
  //     if (error) {
  //       console.log(error);
  //     }

  //     var account = accounts[0];

  //     App.contracts.Adoption.deployed().then(function(instance) {
  //       adoptionInstance = instance;

  //       // Execute adopt as a transaction by sending account
  //       return adoptionInstance.adopt(petId, {from: account});
  //     }).then(function(result) {
  //       return App.markAdopted();
  //     }).catch(function(err) {
  //       console.log(err.message);
  //     });
  //   });
  // }

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
