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
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7903');
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

      // return App.getPatents();
    });
  },

  deployPatent: function() {
    var patent = document.getElementById("patent_text").value;
    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }
      
      var account = accounts[0];
      App.contracts.Patent.deployed().then(function(instance) {
        patentInstance = instance;
        patentInstance.declarePatent(patent, {from: account});
      
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  },

  getPatents: function() {
    var patentInstance;
    var patentList = document.getElementById("own_patents");

    App.contracts.Patent.deployed().then(function(instance) {
      patentInstance = instance;
      return patentInstance.getOwnerPatents.call();
    }).then(function(patents) {
      for (i = 0; i < patents.length; i++) {
        console.log(patents[i]);
        App.addPatent("titulo", patents[i]);
      }
    }).catch(function(err) {
      console.log(err.message);
    });
  },


  getPatentsAll: function() {
    var patentInstance;
    var patentList = document.getElementById("own_patents");
    console.log("cheguei")

    App.contracts.Patent.deployed().then(function(instance) {
      patentInstance = instance;
      return patentInstance.getAllPatents.call();
    }).then(function(patents) {
      for (i = 0; i < patents.length; i++) {
        console.log(patents[i]);
        App.addPatentAll("titulo", patents[i]);
      }
    }).catch(function(err) {
      console.log(err.message);
    });
  },


  addPatent: function(title, content) {
    var elem = document.getElementById("your_patents");
        
        var div_node = document.createElement("DIV");
        div_node.className = "panel-body";

        var p_node = document.createElement("p");

        var strong_node = document.createElement("strong");
        strong_node_text = document.createTextNode(title);
        strong_node.appendChild(strong_node_text);

        p_node.appendChild(strong_node);
        div_node.appendChild(p_node);

        var p_node = document.createElement("p");
        p_node_text = document.createTextNode(content);
        p_node.appendChild(p_node_text);

        div_node.appendChild(p_node);

        elem.appendChild(div_node);
  },

  addPatentAll: function(title, content) {
    var elem = document.getElementById("your_patents");
        
        console.log("cheguei2")
        var div_node = document.createElement("DIV");
        div_node.className = "panel-body";

        var p_node = document.createElement("p");

        var strong_node = document.createElement("strong");
        strong_node_text = document.createTextNode(title);
        strong_node.appendChild(strong_node_text);

        p_node.appendChild(strong_node);
        div_node.appendChild(p_node);

        var p_node = document.createElement("p");
        p_node_text = document.createTextNode(content);

        var button = document.createElement('button');
        button.innerHTML = 'Use Patent';
        button.onclick = function(){
          App.usePatent(content, 1);return false;
        };
        p_node.appendChild(p_node_text);

        div_node.appendChild(p_node);

        elem.appendChild(div_node);
  },

    usePatent: function(content, price) {
      web3.eth.getAccounts(function(error, accounts) {
      
        if (error) {
          console.log(error);
        }
        
        var account = accounts[0];
        App.contracts.Patent.deployed().then(function(instance) {
          patentInstance = instance;
          patentInstance.usePatent(content, price, {from: account});
        
        }).catch(function(err) {
          console.log(err.message);
        });
      });
    },

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
