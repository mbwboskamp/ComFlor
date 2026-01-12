// ComFlor Product Types
export type ComFlorType =
  | 'CF46'
  | 'CF51'
  | 'CF60'
  | 'CF80'
  | 'CF210'
  | 'CF225';

export type ProjectStatus =
  | 'offerte'
  | 'gepland'
  | 'in_uitvoering'
  | 'afgerond'
  | 'gefactureerd';

export type OrderStatus =
  | 'aangevraagd'
  | 'bevestigd'
  | 'in_productie'
  | 'verzonden'
  | 'geleverd';

export type Priority = 'laag' | 'normaal' | 'hoog' | 'urgent';

// Client Model
export interface Client {
  id: string;
  bedrijfsnaam: string;
  contactpersoon: string;
  email: string;
  telefoon: string;
  adres: string;
  postcode: string;
  plaats: string;
  kvkNummer: string;
  btwNummer: string;
  kredietlimiet: number;
  openstaandBedrag: number;
  aantalProjecten: number;
  aangemaaktOp: string;
  laatsteActiviteit: string;
}

// Project Model
export interface Project {
  id: string;
  projectnummer: string;
  naam: string;
  clientId: string;
  clientNaam: string;
  locatie: string;
  status: ProjectStatus;
  startdatum: string;
  einddatum: string;
  projectleider: string;
  totaalOppervlakte: number; // m²
  comflorType: ComFlorType;
  betondikte: number; // mm
  geschatteWaarde: number;
  gefactureerd: number;
  voortgang: number; // percentage
  prioriteit: Priority;
  opmerkingen: string;
  aangemaaktOp: string;
}

// Order Model
export interface Order {
  id: string;
  ordernummer: string;
  projectId: string;
  projectnaam: string;
  clientNaam: string;
  status: OrderStatus;
  comflorType: ComFlorType;
  hoeveelheid: number; // m²
  plaatdikte: number; // mm
  staalsoort: string;
  coating: string;
  gewensteLeverdatum: string;
  werkelijkeLeverdatum?: string;
  totaalPrijs: number;
  leveradres: string;
  opmerkingen: string;
  aangemaaktOp: string;
}

// Material/Inventory Model
export interface Material {
  id: string;
  artikelcode: string;
  naam: string;
  type: ComFlorType;
  dikte: number;
  breedte: number;
  lengte: number;
  voorraad: number; // m²
  minimumVoorraad: number;
  prijsPerM2: number;
  leverancier: string;
  levertijd: number; // dagen
  laatsteInkoop: string;
}

// Invoice Model
export interface Factuur {
  id: string;
  factuurnummer: string;
  projectId: string;
  projectnaam: string;
  clientId: string;
  clientNaam: string;
  factuurdatum: string;
  vervaldatum: string;
  bedragExBtw: number;
  btwBedrag: number;
  totaalBedrag: number;
  betaald: boolean;
  betaaldOp?: string;
}

// Dashboard KPI's
export interface DashboardKPIs {
  totaalProjecten: number;
  actieveProjecten: number;
  openOrders: number;
  omzetDezeMaand: number;
  omzetVorigeMaand: number;
  openstaandeFacturen: number;
  gemiddeldeLevertijd: number;
  klanttevredenheid: number;
  voorraadWaarde: number;
  projectenOpSchema: number;
}

// Chart Data Types
export interface OmzetPerMaand {
  maand: string;
  omzet: number;
  kosten: number;
  winst: number;
}

export interface ProjectenPerStatus {
  status: string;
  aantal: number;
  waarde: number;
  [key: string]: string | number;
}

export interface ComFlorVerkoop {
  type: ComFlorType;
  oppervlakte: number;
  omzet: number;
}

// Activity/Log
export interface Activiteit {
  id: string;
  type: 'project' | 'order' | 'client' | 'factuur';
  actie: string;
  beschrijving: string;
  gebruiker: string;
  tijdstip: string;
  referentieId: string;
}
