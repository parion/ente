import { MenuItem, ButtonProps, Typography, Box } from '@mui/material';
import { FluidContainer } from 'components/Container';
import React from 'react';

interface Iprops {
    onClick: () => void;
    color?: ButtonProps['color'];
    startIcon?: React.ReactNode;
    endIcon?: React.ReactNode;
    children?: any;
}
export function OverflowMenuOption({
    onClick,
    color = 'primary',
    startIcon,
    endIcon,
    children,
}: Iprops) {
    return (
        <MenuItem
            onClick={onClick}
            sx={{
                color: (theme) => theme.palette[color].main,
                padding: 1.5,
                '& .MuiSvgIcon-root': {
                    fontSize: '20px',
                },
            }}>
            <FluidContainer>
                {startIcon && (
                    <Box
                        sx={{
                            padding: 0,
                            marginRight: 1.5,
                        }}>
                        {startIcon}
                    </Box>
                )}
                <Typography variant="button">{children}</Typography>
            </FluidContainer>
            {endIcon && (
                <Box
                    sx={{
                        padding: 0,
                        marginLeft: 1,
                    }}>
                    {endIcon}
                </Box>
            )}
        </MenuItem>
    );
}
