// User page magic
import React from 'react'
import ReactDOM from 'react-dom'

const UserTable = React.createClass({
  getInitialState() {
    return {
      createMailList: false,
      checkedUsers: {},
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
  render() {
    const users = this.props.users
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
              <th>Name</th>
              <th>E-Mail</th>
              <th>Instrument</th>
              <th>Geburtstag</th>
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
