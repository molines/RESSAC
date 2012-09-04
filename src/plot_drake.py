
#####################################################################
## Packages

# Scipy
try:
        from scipy.io import netcdf as nc
except:
        print 'scipy is not available on your machine'
        print 'check python path or install this package' ; exit()

# Matplotlib
try:
	import matplotlib.pylab as plt
except:
        print 'matplotlib is not available on your machine'
        print 'check python path or install this package' ; exit()


#####################################################################
## Functions

def readfull(file,varname):
        fid = nc.netcdf_file(file, 'r')
        out = npy.array(fid.variables[varname][:]).squeeze()
        fid.close()
        return out

#####################################################################

year = readfull('./ORCA025.L75-GRD100_TRANSPORTS.nc','time_counter')
trp  = readfull('./ORCA025.L75-GRD100_TRANSPORTS.nc','vtrp_drake')

plt.figure()

plt.plot(year,-trp,'r.-')
plt.grid()
plt.xlim([1958,2010])
plt.xlabel('years')
plt.ylabel('Transport (Sv)')
plt.title('Drake passage')

plt.savefig('../figs_monitor/ORCA025dotL75-GRD100_transport_drake.png')
