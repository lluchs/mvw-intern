// User page magic
import React from 'react'
import ReactDOM from 'react-dom'
import orderBy from 'lodash/orderBy'

const UserTable = React.createClass({
  getInitialState() {
    return {
      createMailList: false,
      checkedUsers: {},
      sortBy: 'firstname',
      sortDesc: false,
    }
  },
  createMailList() {
    this.setState({createMailList: true})
    this.checkAll()
  },
  checkAll(e) {
    const to = e == null ? true : e.target.checked
    let checkedUsers = {}
    for (let user of this.props.users)
      checkedUsers[user.id] = to
    this.setState({checkedUsers: checkedUsers})
  },
  changeCheck(id) {
    return e => {
      const checked = e.target.checked
      this.setState(({checkedUsers}) =>
        ({checkedUsers: {...checkedUsers, [id]: checked}}))
    }
  },
  sortBy(what) {
    return (e) => {
      this.setState((state) => ({
        sortBy: what,
        sortDesc: what == state.sortBy ? !state.sortDesc : false,
      }))
    }
  },
  sortArrow(what) {
    if (this.state.sortBy == what)
      return this.state.sortDesc ? '↑' : '↓'
    else
      return ''
  },
  render() {
    let users = this.props.users
      .map(user => {
        let [first, last] = user.name.split(' ')
        return {...user, firstname: first, lastname: last}
      })
    users = orderBy(users, this.state.sortBy, this.state.sortDesc ? 'desc' : 'asc')

    const checkedUsers = this.state.checkedUsers
    return (
      <div>
        <p>
          {!this.state.createMailList &&
            <button onClick={this.createMailList} className="pure-button">Mail-Liste erstellen…</button>}
          {this.state.createMailList &&
            <a href={'mailto:'+createMailList(users.filter(u => checkedUsers[u.id]))} className="pure-button pure-button-primary">Mail schreiben</a>}
        </p>
        <table className="pure-table pure-table-horizontal">
          <thead>
            <tr>
              {this.state.createMailList &&
                <th><input type="checkbox" onChange={this.checkAll} defaultChecked /></th>}
              <th>
                <span onClick={this.sortBy('firstname')}>Vorname {this.sortArrow('firstname')}</span> /&nbsp;
                <span onClick={this.sortBy('lastname')}>Nachname {this.sortArrow('lastname')}</span>
              </th>
              <th onClick={this.sortBy('email')}>E-Mail {this.sortArrow('email')}</th>
              <th onClick={this.sortBy('instrument')}>Instrument {this.sortArrow('instrument')}</th>
              <th onClick={this.sortBy('birthday')}>Geburtstag {this.sortArrow('birthday')}</th>
            </tr>
          </thead>
          <tbody>
            {users.map(user =>
              <tr key={user.id}>
                {this.state.createMailList &&
                  <td><input type="checkbox" onChange={this.changeCheck(user.id)} checked={checkedUsers[user.id]} /></td>}
                <td>
                  {this.props.admin ?
                    <a href={`/user/${user.id}/edit`}>{user.name}</a> :
                    user.name}
                </td>
                <td>{user.email}</td>
                <td>{user.instrument}</td>
                <td>{formatBirthday(user.birthday)}</td>
              </tr>)}
          </tbody>
        </table>
      </div>
    )

    function formatBirthday(birthday) {
      return birthday && new Date(birthday).toLocaleDateString('de-DE').replace(/\d+$/, '')
    }

    function createMailList(users) {
      return users
        .map(user => `${user.name} <${user.email}>`)
        .join(', ')
    }
  }
})

let users = JSON.parse(document.getElementById('users-data').textContent)

ReactDOM.render(
  <UserTable users={users} admin={document.body.dataset.admin == 'true'} />,
  document.getElementById('users-table'))

// vim: ft=javascript.jsx
