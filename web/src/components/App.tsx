import React, {useState} from 'react';
import './App.css'
import {debugData} from "../utils/debugData";
import {fetchNui} from "../utils/fetchNui";
import { useDisclosure } from '@mantine/hooks';
import { Button, Card, Drawer, Image, Group, Text, MantineProvider, Badge, Stack, Space, Footer, Divider, Accordion, Title, ScrollArea } from '@mantine/core';
import CityUI from './drawer';

debugData([
  {
    action: 'setVisible',
    data: true,
  }
])



const App: React.FC = () => {
  return (
    <MantineProvider theme={{ colorScheme: 'dark' }}>
      <CityUI />
    </MantineProvider>
  );
}

export default App;
