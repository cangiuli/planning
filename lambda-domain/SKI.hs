module SKI where

data Comb = S | K | I | Const String | App Comb Comb |
            S1 Comb | S2 Comb Comb | K1 Comb
  deriving Show
data Frame = Eval Comb | Cont Comb | Retn Comb
  deriving Show

step ((Eval (App x y)):fs) = [Eval x,Cont y] ++ fs
step ((Eval comb):fs) = (Retn comb):fs
step ((Retn comb):(Cont c):fs) = f:fs where
  f = case comb of
        I      -> Eval c
        K1 x   -> Eval x
        S2 x y -> Eval (App (App x c) (App y c))
        K      -> Retn (K1 c)
        S      -> Retn (S1 c)
        S1 x   -> Retn (S2 x c)

test = [Eval (App (App K (Const "a")) (Const "b"))]
test' = [Eval (App (App (App S K) K) (Const "a"))]
test'' = [Eval (App I (App I (Const "a")))]

{-
Eval-App:
(eval l e l')
(App e ex ey)
->
(eval l ex l'')
(cont l'' ey l')

Eval-S:
(eval l e l')
(S e)
->
(retn l e l')
(S e)

Eval-K:
(eval l e l')
(K e)
->
(retn l e l')
(K e)

Eval-I:
(eval l e l')
(I e)
->
(retn l e l')
(I e)

Eval-S1:
(eval l e l')
(S1 e ex)
->
(retn l e l')
(S1 e ex)

Eval-S2:
(eval l e l')
(S2 e ex ey)
->
(retn l e l')
(S2 e ex ey)

Eval-K1:
(eval l e l')
(K1 e ex)
->
(retn l e l')
(K1 e ex)

--------------------------------------------------------------------------------

Retn-I:
(retn l e l')
(cont l' ec l'')
(I e)
->
(eval l ec l'')

Retn-K1:
(retn l e l')
(cont l' ec l'')
(K1 e ex)
->
(eval l ec l'')

Retn-S2:
(retn l e l')
(cont l' ec l'')
(S2 e ex ey)
->
(eval l e' l'')
(app e' e1' e2')
(app e1' ex ec)
(app e2' ey ec)

Retn-K:
(retn l e l')
(cont l' ec l'')
(K e)
->
(retn l e' l'')
(K1 e' ec)

Retn-S:
(retn l e l')
(cont l' ec l'')
(S e)
->
(retn l e' l'')
(S1 e' ec)

Retn-S1:
(retn l e l')
(cont l' ec l'')
(S1 e ex)
->
(retn l e' l'')
(S2 e' ex ec)

-}
