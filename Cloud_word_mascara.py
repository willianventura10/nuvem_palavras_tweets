#importa bibliotecas
import pandas as pd
from os import path
from PIL import Image
import numpy as np
import matplotlib.pyplot as plt
import os
from wordcloud import WordCloud, STOPWORDS

#define máscara para forma da nuvem 
d = path.dirname(__file__) if "__file__" in locals() else os.getcwd()
mask_c = np.array(Image.open(path.join(d, "silhueta.png")))

#importa tweets baixados no R com rtweet
df = pd.read_csv("tweets.csv")
freq = df.drop(columns=['Unnamed: 0'])

#transforma dataframe em tuplas para usar no wordcloud
tuples = [tuple(x) for x in freq.values]

#define configurações para wordcloud
wc = WordCloud(background_color="white", max_words=2000, mask=mask_c,contour_width=3, contour_color='steelblue').generate_from_frequencies(dict(tuples))

#salva image no diretório
wc.to_file(path.join(d, "nuvem_jogador.png"))

# show
plt.imshow(wc, interpolation='bilinear')
plt.axis("off")
plt.figure()
plt.imshow(mask_c, cmap=plt.cm.gray, interpolation='bilinear')
plt.axis("off")
plt.show()