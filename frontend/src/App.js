import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';

class App extends Component {
  apiURL = `/api`;

  constructor(props, context) {
    super(props, context);

    this.state = { greeting: "no greeting yet" };
  }

  loadGreetingFromServer() {
    fetch(this.apiURL)
      .then(result => result.json())
      .then(data => {
        this.setState(data);
        console.log(this.state.greeting);
      })
      .catch(error => console.log("Could not connect to " + this.apiURL));
  }

  componentDidMount() {
    this.loadGreetingFromServer();
  }
 
  render() {
    return (
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <h1 className="App-title">Welcome to React</h1>
        </header>
        <p className="App-intro">
          To get started, edit <code>src/App.js</code> and save to reload.
        </p>
        <p id="greeting">{this.state.greeting}</p>
      </div>
    );
  }
}

export default App;