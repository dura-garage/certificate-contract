import React from 'react';
import './App.css';
import Layout from './components/Navigation/Layout';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Home from './pages/Home';
import Admin from './pages/Admin';
import User from './pages/User';
import Organisation from './pages/Organisation';
function App() {
  return (
    <div className="App">
      <Router>
        <Layout>
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/admin" element={<Admin />} />
            <Route path="/user" element={<User />} />
            <Route path="/organisation" element={<Organisation />} />
          </Routes>

        </Layout>
      </Router>
    </div>
  );
}

export default App;
