--consultas em ordem igual ao documento pdf
--1
select *
from venda
where data > '2018-09-01' and data < '2018-09-15'

--2
select qp.codbarras, qp.descricao, sum(QuantidadeProdutos) as quantidade
from(
select p.descricao, p.codbarras,quantidadelotes * produtoslote as QuantidadeProdutos
from produto p join estoque e on p.codbarras = e.codBarrasProduto) as qp
group by qp.codbarras, qp.descricao
order by quantidade

--3
select descricao, datavalidade
from estoque e join produto p on e.codbarrasproduto = p.codbarras
where datavalidade >= '2019-01-01' and datavalidade <= '2020-10-25'
order by datavalidade, p.descricao asc

--4
select p.descricao, e.datafornecimento
from produto p, estoque e 
where p.codbarras = e.codbarrasproduto
order by e.datafornecimento 

--5
select tf.telefone
from telefonefornecedor tf, fornecedor f
where tf.cnpj = f.cnpj and f.nome = 'Dw Acessórios'

--6
select p.nome, f.matricula, c.valor as valorCompra
from compra c, funcionario f, pessoa p
where c.matfuncionario = f.matricula and f.cpf = p.cpf and codigo = 3

--7
select f.matricula, f.cpf, f.dataadmissao, f.salario
from setor s, funcionario f, pessoa p
where f.codsetor = s.codigo and f.cpf = p.cpf and s.nome = 'atendimento'

--8
select f.matricula, p.nome
from ((funcionario f join pessoa p on p.cpf = f.cpf) join gerenciasetor gc on f.matricula = gc.gerente) join setor s on gc.codsetor = s.codigo
where s.nome = 'atendimento' and datafim is null

--9
select p.nome, f.salario
from funcionario f join pessoa p on f.cpf = p.cpf

--10
select sum(valor) as total
from venda
where formapagamento = 'cartão' and data >= '2018-09-07' and data < '2018-09-11'

--11
select valorunid, descricao
from produto
where codbarras = '0364-3740'

--12
select nome, matricula
from(
select *
from funcionario f
where not exists 
(
select *
from gerenciasetor gs
where f.matricula = gs.gerente and datafim is null
)) as tab, pessoa p
where tab.cpf = p.cpf

--13
select s.nome, count(*) as qtdfuncionarios
from funcionario f join setor s on f.codsetor = s.codigo
group by s.codigo, s.nome

--14
select *
from produto
where descricao LIKE 'B%'

--15
select p.cpf, p.nome, f.salario, f.dataadmissao
from funcionario f join pessoa p on f.cpf = p.cpf
where nome LIKE 'Bernardo%'

--16
(select fp.cnpj 
from fornecedorproduto fp, produto p
where fp.codbarrasproduto = p.codbarras and p.descricao = 'MACARRÃO - Econômico Supermercado'
except 
select fp.cnpj 
from fornecedorproduto fp, produto p
where fp.codbarrasproduto = p.codbarras and p.descricao = 'BATOM MATE SOUL KISS - Dw Acessórios')

--17
select codbarras, descricao, sum(quantidade) quantProdutos
from
(
select *
from venda v, vendaProduto vp, produto p
where v.codvenda = vp.codvenda and p.codbarras = vp.codbarrasproduto and v.data > '2018-09-01' and v.data < '2018-09-30'
) v
group by codbarras, descricao
having sum(quantidade)>30
order by sum(quantidade) desc

--18
select *
from produto p
where not exists(
select *
from estoque e
where e.codbarrasproduto = p.codbarras
)

--19
(select codVenda
from venda v
where valor > 100
intersect 
select codVenda
from venda v
where formapagamento = 'dinheiro')

--Criação dos indices
CREATE INDEX pessoaindice ON Pessoa(CPF);
CREATE INDEX clienteindice ON Cliente(CPF);
CREATE INDEX setorindice ON Setor(codigo);
CREATE INDEX funcionarioindice ON Funcionario(matricula);
CREATE INDEX gerenciasetorindice ON GerenciaSetor(gerente);
CREATE INDEX vendaindice ON Venda(codVenda);
CREATE INDEX clientevendaindice ON ClienteVenda(cpfCliente);
CREATE INDEX compraindice ON Compra(codigo);
CREATE INDEX cartaoindice ON Cartão(numero);
CREATE INDEX vendacartaoindice ON VendaCartao(numeroCartao);
CREATE INDEX fornecedorindice ON Fornecedor(CNPJ);
CREATE INDEX telefonefornecedorindice ON TelefoneFornecedor(telefone);
CREATE INDEX comprafornecedorindice ON CompraFornecedor(codCompra);
CREATE INDEX produtoindice ON Produto(codBarras);
CREATE INDEX fornecedorprodutoindice ON FornecedorProduto(codBarrasProduto);
CREATE INDEX compraprodutoindice ON CompraProduto(codCompra);
CREATE INDEX vendaprodutoindice ON VendaProduto(codVenda);
CREATE INDEX estoqueindice ON Estoque(idLote);

--Criação das tabelas, ordem do documento pdf
--1
CREATE VIEW ProdutoInfo as
select codBarrasProduto, descricao, produtosVendidos, quantVendas, quantProdutoEstoque
from(
	(select codbarrasproduto, sum(quantidadelotes * produtoslote) as quantProdutoEstoque
	from estoque 
	group by codbarrasproduto) tab1

	natural full join

	(select vp.codbarrasproduto, p.descricao, sum(quantidade) as produtosVendidos, count(*) as quantVendas
	from vendaproduto vp join produto p on codbarrasproduto = codbarras
	group by vp.codbarrasproduto, p.descricao) tab2
	) tab3
order by quantVendas desc, produtosVendidos desc, descricao

--2
CREATE VIEW FornecedorProdutoNomes as
select nome, descricao
from (fornecedor f natural join fornecedorProduto fp), produto p
where p.codbarras = fp.codbarrasproduto 

--3
create view TelefoneFonecedorView as
select f.nome, tf.telefone
from fornecedor f natural join telefonefornecedor tf
order by f.nome

--Criação dos procedimentos armazenados, ordem do documento pdf
--1
create function vendaTotalFuncionario(CHARACTER(6))
returns real as $$
declare 
	matFunc alias for $1;
	total real:=0;
begin
	select into total sum(valor)
	from venda 
	where matfuncionario = matFunc
	group by matfuncionario;
	return total;
end
$$ language plpgsql

--2
create function funcionariosGerentes(integer)
returns integer as $$
declare 
	codigosetor alias for $1;
	quantidade integer:=0;
begin
	select into quantidade count(gerente)
	from gerenciasetor g
	where g.codsetor=codsetor and datafim is not null
	group by g.codsetor;
	return quantidade + 1;
end 
$$ language plpgsql

--Criação dos gatilhos, ordem do documento pdf
--1
create function verificadata()
	returns trigger as $$
	declare 

	begin
		if new.datavalidade<=now() then return null;
			else return new;
		end if;
	end $$ language PLPGSQL;

create trigger verificaDataValidadeProduto before
insert or update on estoque
for each row
execute procedure verificadata();

--2
create function verificaCodigoSetor()
returns trigger as $$
declare
	codSetorMaior Funcionario.codSetor%type;
begin
	select into codSetorMaior max(codSetor) from Funcionario;
	if new.codSetor>codSetorMaior then return null;
		else return new;
	end if;
	 
end
$$ language plpgsql;

create trigger verificaCodigoSetorFuncionario before
insert or update on Funcionario
for each row
execute procedure verificaCodigoSetor(); 