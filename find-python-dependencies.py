import sys
name = sys.argv[1]
__import__(name)
print(' '.join(
     [modu.__file__ for modu in sys.modules.values() 
          if '__file__' in dir(modu) 
          and modu.__file__ is not None]
))
