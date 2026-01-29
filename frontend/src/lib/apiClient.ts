import axios from 'axios';

const DEFAULT_API_BASE_URL = `${window.location.origin}/api`;
const RAW_API_BASE_URL = import.meta.env.VITE_API_BASE_URL;
const NORMALIZED_API_BASE_URL = RAW_API_BASE_URL
    ? `${RAW_API_BASE_URL.replace(/\/$/, '')}${RAW_API_BASE_URL.endsWith('/api') ? '' : '/api'}`
    : DEFAULT_API_BASE_URL;

export const apiClient = axios.create({
    baseURL: NORMALIZED_API_BASE_URL,
    withCredentials: true, // Crucial for httpOnly cookies
});
