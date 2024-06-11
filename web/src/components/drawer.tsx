import { useEffect, useState } from 'react';
import { Button, Card, Drawer, Image, Group, Text,MantineProvider, Badge, Stack, Space, Divider, Title, ScrollArea, Avatar} from '@mantine/core';
import { fetchNui } from '../utils/fetchNui';
import { useNuiEvent } from '../hooks/useNuiEvent';
import { Carousel } from '@mantine/carousel';

const image1 = '../assets/images/1.jpeg';
const image2 = '../assets/images/2.jpeg';
import image6 from '../assets/images/404.svg';

interface VisibilityProviderValue {
    setVisible: (visible: boolean) => void;
    visible: boolean;
}

export function CityUI () {
    const [isDrawerOpened, setVisible] = useState(false);
    const [IsRegisterOpened, setIsRegisterOpened] = useState(false);
    const [IsJobOpened, setIsJobOpened] = useState(false);
    const [colorScheme, setColorScheme ] = useState('yellow');

    useNuiEvent('colorScheme', (color: string) => {
        setColorScheme(color);
    });

    const toggleDrawer = () => { setVisible(!isDrawerOpened)};
    const CloseDrawer = async () => { setVisible(false); fetchNui('closeCityUI'); };
    const CloseRegister = () => { setIsRegisterOpened(false); setVisible(true);}
    const CloseJob = () => { setIsJobOpened(false); setVisible(true);}

    const [userName, setUserName] = useState('Jenna Foster');
    const [userJob, setUserJob] = useState('Civilian');

    useNuiEvent<boolean>('setVisible', setVisible);

    useNuiEvent('userinfo', (data) => {
        setUserName(data.name);
        setUserJob(data.job);
    });

    const AutoCard = () => {
        interface Data {
            id: number;
            name: string;
            price: number;
        }

        const [data, setData] = useState<Data[]>([]);

        useNuiEvent('RegisterLicense', (receivedData: Data[]) => {
            setData(receivedData);
        });


        const OnClickData = (clickedItem: Data) => {
            const data = {
                name: clickedItem.name,
                price: clickedItem.price,
            };

            fetchNui('BuyLicense', data);
            setIsRegisterOpened(false);
            toggleDrawer();
        };
        return (
            <Carousel>
                {data.length === 0 ? (
                    <Carousel.Slide size={700} gap={10}>
                        <Group grow align="center" spacing="xs" mt="sm" mb="sm">
                            <Card shadow="md" padding="md" radius="lg">
                            <Text size="xl" align="center" weight={700}>404</Text>
                            <Image src={image6} height="70" width="100%"  fit='cover' />
                            <Divider my="sm" />
                            <Space h="md" />
                            <Button variant="light" color= {colorScheme} loading fullWidth>
                                Failed
                            </Button>
                            </Card>
                        </Group>
                    </Carousel.Slide>
                ) : (
                    data.map((item) => (
                        <Carousel.Slide key={item.id} size={700} gap={10}>
                            <Card shadow="md" padding="md" radius="lg">
                                <Text size="xl" align="center" weight={700}>{item.name}</Text>
                                <Divider my="sm" />
                                <Space h="sm" />
                                <Badge radius="xs" size="lg" variant="light" color="blue">
                                    ${item.price}
                                </Badge>
                                <Space h="sm" />
                                <Button variant="light" color= {colorScheme} onClick={() => OnClickData(item)} fullWidth>
                                    Buy
                                </Button>
                            </Card>
                        </Carousel.Slide>
                    ))
                )}
            </Carousel>
        );
    };

    const JobCard = () => {
        interface Data { name : string;}
        const [data, setData] = useState<Data[]>([]);

        useNuiEvent('JobList', (receivedData: Data[]) => {
            setData(receivedData);
        });

        const OnClickData = (clickedItem: Data) => {
            const data = {name: clickedItem.name,};
            fetchNui('RequestJob', data);
            setIsJobOpened(false);
            toggleDrawer();
        };

        return (
            <Carousel>
            {data.length === 0 ? (
                <Carousel.Slide size={700} gap={10}>
                    <Group grow align="center" spacing="xs" mt="sm" mb="sm">
                        <Card shadow="md" padding="md" radius="lg">
                            <Text size="xl" align='center' weight={700}>404</Text>
                            <Divider my="sm" />
                            <Image src={image6} height="70" width="100%"  fit='cover' />
                            <Space h="md" />
                            <Button variant="light" color= {colorScheme} loading fullWidth>Failed</Button>
                        </Card>
                    </Group>
                </Carousel.Slide>
              ) : (
                data.map((item) => (
                  <Carousel.Slide key={item.name} size={700} gap={10}>
                    <Card shadow="md" padding="md" radius="lg">
                      <Text size="xl" align='center' weight={700}>{item.name}</Text>
                      <Divider my="sm" />
                      <Space h="md" />
                      <Badge radius="xs" size="lg" variant="light" color="blue">Available</Badge>
                      <Space h="sm" />
                      <Button variant="light" color= {colorScheme} onClick={() => OnClickData(item)} fullWidth>
                        Apply Here
                      </Button>
                    </Card>
                  </Carousel.Slide>
                ))
              )}
            </Carousel>
        );
    };
    const handleRegisterClick = () => { setIsRegisterOpened(true); setVisible(false); fetchNui('RegisterLicense');};
    const handleJobClick = () => { setIsJobOpened(true); setVisible(false); fetchNui('Joblist');};

    return (
        <><><Drawer opened={isDrawerOpened} onClose={CloseDrawer} size='md' position="right" padding="sm" title='Los Santos City Hall'>
            <ScrollArea type='never' h={1020}>
                <Group align="center" spacing="xs"  mt="sm" mb="sm">
                <Avatar radius="xl" size="md" />
                <Text>{userName}</Text>
                    <Badge radius="xs" variant="light" color="blue">
                        {userJob}
                    </Badge>
                </Group>
                <Stack>
                    <Card shadow="sm" padding="sm" radius="md">
                        <Group align="center" mt="xs">
                            <Text size="xl" weight={700}>Available Jobs</Text>
                            <Space h="md" />
                            <Divider my="sm" />
                            <Image src= {image1} height={100} />
                            <Button variant="light" color= {colorScheme} onClick={handleJobClick} fullWidth>Apply Job</Button>
                            <Text size="md">Homless? You can apply here for a job</Text>
                        </Group>
                    </Card>

                    <Card shadow="sm" padding="sm" radius="md">
                        <Group align="center" mt="xs">
                            <Text size="xl" weight={700}>Available Licenses</Text>
                            <Space h="md" />
                            <Divider my="sm" />
                            <Image src= {image2} height={100} />
                            <Button variant="light" color={colorScheme} onClick={handleRegisterClick} fullWidth>Register License</Button>
                            <Text size="md" >Lost your license while busy with your daily life? You can register brand new license here.</Text>
                        </Group>
                    </Card>

                    <Divider my="sm" />
                </Stack>
            </ScrollArea>
        </Drawer>
            <Drawer opened={IsRegisterOpened} onClose={CloseRegister} position="bottom" padding="md" size={390}>
                <Title order={4} className="title" ta="center" mt="sm">Available Licenses</Title>
                <Space h="sm" />
                <Group align="center" grow position='center' spacing='sm' mt='xs' mb='lg'>
                  {AutoCard()}
                </Group>
            </Drawer>
        </>
        <Drawer opened={IsJobOpened} onClose={CloseJob} position="bottom" padding="md" size={390}>
                <Title order={4} className="title" ta="center" mt="sm">Available Jobs</Title>
                <Space h="sm" />
                <Group align="center" grow position='center' spacing='sm' mt='xs' mb='lg'>
                    {JobCard()}
                </Group>
        </Drawer></>
    );
}

export default function Main() {
    return (
    <MantineProvider theme={{ colorScheme: 'dark' }}>
        <CityUI />
    </MantineProvider>
    );
}