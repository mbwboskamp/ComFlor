import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { Layout } from './components';
import {
  Dashboard,
  Projects,
  Orders,
  Clients,
  Materials,
  Reports,
  Settings,
} from './pages';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Layout />}>
          <Route index element={<Dashboard />} />
          <Route path="projecten" element={<Projects />} />
          <Route path="orders" element={<Orders />} />
          <Route path="klanten" element={<Clients />} />
          <Route path="materialen" element={<Materials />} />
          <Route path="rapportages" element={<Reports />} />
          <Route path="instellingen" element={<Settings />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;
