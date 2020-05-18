import React, { Component } from 'react';
import _ from 'lodash';


export default class hudTile extends Component {
  constructor(props){
    super(props);
    this.state = {
      page: "home",
      patp: ""
    };
    let api = window.api;
  }

 querySubmit() {
   event.preventDefault();
   let queryInput = document.getElementById('qry');
   let query = {
     "patp-query":queryInput.value
   }
  
     api.action('hud', 'json', query);
     this.setState({patp: queryInput.value});
   queryInput.value="";
  }

  renderWrapper(child) {
    return (
      <div className="relative white"
      style={{
        width: 126,
        height: 126,
      }}>
      {child}
      </div>
    );
  }

  renderHome() {
    return this.renderWrapper(
      <div
    className={"pa2 w-100 h-100 b--black b--gray1-d ba " +
      "bg-white bg-gray0-d black white-d"}>
        <img className="invert-d"
        src='/~hud/img/hud-.png'
        width={20}
        height={14} />
        <p className="f9 absolute"
          style={{left: 35, top: 9}}>
          Hud
        </p>
        <div
      onClick={() => this.setState({page: "sys"})}>
      <p className="absolute w-100 flex-col"
        style={{fontSize: '0.6em', verticalAlign: "top", horizontalAlign: "left", top: 36, left: 12, cursor: "pointer"}}>
        -> System
        </p>
      </div>
      <div
      onClick={() => this.setState({page: "ver"})}>
      <p className="absolute w-100 flex-col"
        style={{fontSize: '0.6em', verticalAlign: "top", horizontalAlign: "left", top: 64, left: 12, cursor: "pointer"}}>
        -> Version
        </p>
      </div>
      <div
      onClick={() => this.setState({page: "com"})}>
      <p className="absolute w-100 flex-col"
        style={{fontSize: '0.6em', verticalAlign: "top", horizontalAlign: "left", top: 92, left: 12, cursor: "pointer"}}>
        -> Communication
        </p>
      </div>
    </div>
    );
  }

  renderVersion() {
    let data = this.props.data;
    let baseroll = data.base || 'Base hash not set.';
    let baselast = baseroll.slice(baseroll.lastIndexOf('.'));
    let homeroll = data.home || 'Home hash not set.';
    let homelast = homeroll.slice(homeroll.lastIndexOf('.'));
//
    return this.renderWrapper(
      <div
    className={"pa2 w-100 h-100 b--black b--gray1-d ba " +
      "bg-white bg-gray0-d black white-d"}>
        <p className="f9 absolute"
          style={{left: 8, top: 8}} onClick={() => this.setState({page: "home"})}>
          ⟵ Version
        </p>
        <div className="relative w-100 flex-col" style={{fontSize: '0.6em', marginTop: '26px'}} title={baseroll}>Base Hash: {baselast}</div>
        <div className="relative w-100 flex-col" style={{fontSize: '0.6em', marginTop: '8px'}}  title={baseroll}>Home Hash: {homelast}</div>
      </div>
    );
  }

  renderSystem() {
    let data = this.props.data;
    let uptime = data.uptime || 'Uptime not set.';
    let lifenum = data.life || 'Lifes.'
    let riftnum = data.rift || 'Rifts.'
//
    return this.renderWrapper(
      <div
        className={"pa2 w-100 h-100 b--black b--gray1-d ba " +
        "bg-white bg-gray0-d black white-d"}>
        <p className="f9 absolute"
          style={{left: 8, top: 8}} onClick={() => this.setState({page: "home"})}>
          ⟵ System
        </p>
        
        <div className="relative w-100 flex-col" style={{fontSize: '0.6em', marginTop: '32px'}}  title="Uptime"> Uptime: {uptime}</div>
        <div classname="relative w-100 flex-col" style={{fontSize: '0.6em', paddingTop: '8px'}}  title="Life"> Current Life: {lifenum}</div>
        <div classname="relative w-100 flex-col" style={{fontSize: '0.6em', paddingTop: '8px'}}  title="Rift"> Current Rift: {riftnum}</div>
      </div>
    );
  }

  renderCommunication() {
    let data = this.props.data;
    let olifenum = data.olife || '-'
    let oriftnum = data.orift || '-'
//
    return this.renderWrapper(
      <div
    className={"pa2 w-100 h-100 b--black b--gray1-d ba " +
      "bg-white bg-gray0-d black white-d"}>
        <p className="f9 absolute"
          style={{left: 8, top: 8}} onClick={() => this.setState({page: "home"})}>
          ⟵ Communication
        </p>

        <form className="flex: 2" style={{paddingTop: '26px', marginBlockEnd: 0 }}>
          <input
            id="qry"
            className="w-100 black white-d bg-transparent bn f9"
            type="text"
            placeholder="enter ship name"
            onKeyDown={(e) => {
              if (e.key === "Enter") {
                e.preventDefault();
                this.querySubmit(e.target.value);
              }}
            }/>
        </form>

        <div className="relative w-100 flex-col" style={{fontSize: '0.6em', paddingTop: '6px'}}  title="target ship"> target ship: {this.state.patp}</div>
        <div className="relative w-100 flex-col" style={{fontSize: '0.6em', paddingTop: '6px'}}  title="target ship"> her life: {olifenum}</div>
        <div className="relative w-100 flex-col" style={{fontSize: '0.6em', paddingTop: '6px'}}  title="target ship"> her rift: {oriftnum}</div>
        </div>
    );
  }


  render() {   
    if (this.state.page === "home") {
      return this.renderHome();
    }
    if (this.state.page === "sys") {
      return this.renderSystem();
    }
    if (this.state.page === "com") {
      return this.renderCommunication();
    }
    if (this.state.page === "ver") {
      return this.renderVersion();
    }
    return this.renderError();
    }
} 

window.hudTile = hudTile;